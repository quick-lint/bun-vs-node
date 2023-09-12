#define _GNU_SOURCE 1
#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include <pty.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static long long timespec_to_us(struct timespec ts) {
  return ((long long)ts.tv_sec * 1000*1000) + (long long)ts.tv_nsec / 1000;
}

static long long total_us = 0;
static long long log_count = 0;
static void log_times(struct timespec before, struct timespec after) {
  long long sample = timespec_to_us(after) - timespec_to_us(before);
  total_us += sample;
  log_count += 1;
  printf("%lld us\n", sample);
}

static bool wait_for_message(int fd, const char* message) {
  size_t message_size = strlen(message);

  char data[64*1024];
  size_t bytes_read = 0;
read_again:
  ssize_t rc = read(fd, data + bytes_read, sizeof(data) - bytes_read);
  if (rc == -1) {
    perror("read");
    exit(1);
  }
  if (rc == 0) {
    return false;
  }
  bytes_read += rc;
  if (memmem(data, bytes_read, message, message_size) != NULL) {
    return true;
  }
  goto read_again;
}

int main(int argc, char** argv) {
  const char* file_to_touch = argv[1];
  int master_fd;
  pid_t child_pid = forkpty(&master_fd, NULL, NULL, NULL);
  if (child_pid == -1) {
    perror("forkpty");
    exit(1);
  }
  if (child_pid == 0) {
    // child
    execvp(argv[2], &argv[2]);
    puts("execvp");
    exit(1);
  } else {
    // parent
    wait_for_message(master_fd, "Server running:");

    for (int i = 0; i < 50; ++i) {
      int file_fd = open(file_to_touch, O_RDWR);
      if (file_fd == -1) {
        perror("open");
        exit(1);
      }
      struct timespec before_write;
      clock_gettime(CLOCK_MONOTONIC, &before_write);
      write(file_fd, "/", 1);
      close(file_fd);
      wait_for_message(master_fd, "Server running:");
      struct timespec after_rerun;
      clock_gettime(CLOCK_MONOTONIC, &after_rerun);
      log_times(before_write, after_rerun);
      usleep(10 * 1000);
    }

    kill(child_pid, SIGTERM);

    fprintf(stderr, "avg: %lld us\n", total_us / log_count);
  }
}

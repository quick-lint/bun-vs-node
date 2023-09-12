// Run a program inside a pseudoterminal. Used to work around crashes in
// 'yarn test' on Linux and crashes in 'bun test' on macOS when benchmarking
// with Hyperfine.

#include <errno.h>
#include <pty.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char** argv) {
  int master_fd;
  pid_t child_pid = forkpty(&master_fd, NULL, NULL, NULL);
  if (child_pid == -1) {
    perror("forkpty");
    exit(1);
  }
  if (child_pid == 0) {
    // child
    execvp(argv[1], &argv[1]);
    puts("execvp");
    exit(1);
  } else {
    // parent
    {
      char buffer[1024*1024];
read_again:
      ssize_t rc = read(master_fd, buffer, sizeof(buffer));
      if (rc == -1 && errno != EIO) {
        perror("read");
        exit(1);
      }
      if (rc > 0) {
        (void)write(STDOUT_FILENO, buffer, rc);
        goto read_again;
      }
    }


    int status = 0;
    pid_t rc = waitpid(child_pid, &status, 0);
    if (rc == -1) {
      perror("waitpid");
      exit(1);
    }
    if (rc != child_pid) {
      puts("???");
      exit(2);
    }
    exit(status ? 1 : 0);
  }
}

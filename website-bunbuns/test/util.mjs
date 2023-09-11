import { expect } from "bun:test";

// Bun does not support expect().rejects.toThrow().
export function expectToBeRejectedWithErrorAsync(promise, ...expectation) {
  return promise.then(
    () => {
      expect(() => {}).toThrow(...expectation);
    },
    (error) => {
      expect(() => {
        throw error;
      }).toThrow(...expectation);
    }
  );
}

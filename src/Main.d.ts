export type User = { email: string; displayName: string; emailVerified: boolean };

export namespace Elm {
  export namespace Main {
    export interface App {
      ports: Ports;
    }

    export interface Args {
      node: HTMLElement;
      flags?: Flags | null;
    }

    /* eslint @typescript-eslint/no-empty-interface: 0 */
    export interface Flags {
      user: User | null;
    }

    export interface Ports {
      requestItem: Subscribe<string>;

      receiveItem: Send<{ key: string; value: string | null }>;

      setItem: Subscribe<{ key: string; value: string }>;

      signIn: Subscribe<{ email: string; password: string }>;

      signOut: Subscribe<void>;

      authStateChanged: Send<User | null>;
    }

    export interface Subscribe<T> {
      subscribe(callback: (value: T) => void): void;
    }

    export interface Send<T> {
      send(value: T): void;
    }

    export function init(args: Args): App;
  }
}

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
    export interface Flags {}

    export interface Ports {
      requestItem: Subscribe<string>;

      receiveItem: Send<{ key: string; value: string | null }>;

      setItem: Subscribe<{ key: string; value: string }>;
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

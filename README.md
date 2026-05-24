
<p align='center'>
ProxLock Icon Placeholder
</p>

# **ProxLock**

ProxLock is a small native utility app that runs in your macOS menu bar and allows you to automatically lock and wake up your Mac by monitoring how far away you are from it. In order to do that, it connects via Bluetooth with one of your Apple devices, such as an Apple Watch, AirPods, or iPhone.

- When you're close to your Mac, ProxLock will attempt to wake him up and redirect you to the lock screen. At this point you either enter your password, use Touch ID or, for the most streamlined experience, use the built-in "Unlock with Apple Watch" to jump straight at the Desktop without you doing absolutely anything.

- When you're farther away, ProxLock will lock the screen by putting Mac to sleep (black screen) or by jumping to the screensaver.

## Development Goals

In addition to implementing the core functionalities described above, I'd like to:

- Implement a way to run user-defined scripts when ProxLock locks or unlocks Mac;
- Implement some code that removes Apple Watch from the usable devices if it's off the wrist for some reason. That could be useful in cases where the watch is charging: since it's still on, it will continue to emit a Bluetooth signal, but that is useless to infer how distant the user is from the computer (it could trigger a lock event if you move away from the charging Apple Watch!).

## Inspiration

I took inspiration from a very cool open-source project named [`BLEUnlock`](https://github.com/ts1/BLEUnlock).

## Requirements

- A Mac that supports Bluetooth LE and runs macOS Sequoia 15 or newer.
- iPhone >= 5s / any kind of Apple Watch / any kind of AirPods.

## Development

Build from the command line:

```sh
make build
```

Install optional local formatting and linting tools:

```sh
make bootstrap
```

Then run:

```sh
make check
```

### VS Code

Install the recommended workspace extensions when VS Code prompts you. They provide SourceKit-LSP, SwiftFormat, and SwiftLint integration.
For this Xcode project, initialize SourceKit-LSP build settings once after `make bootstrap`:

```sh
make lsp-config
```

Run `ProxLock: Configure SourceKit-LSP` again from VS Code after changing schemes, targets, or build settings. Build once in Xcode or with `make build` if SourceKit-LSP diagnostics look stale.
Swift files are formatted on save with SwiftFormat. SwiftLint fixes are applied on save where SwiftLint can safely autocorrect them.

### Xcode

Xcode uses the same project, SwiftFormat, and SwiftLint configuration. It does not provide reliable third-party format-on-save hooks, so use:

```sh
make format
make check
```

For editor integration, install SwiftFormat's Xcode Source Editor Extension and run it manually from Xcode's Editor menu when needed.

## Authors

- **Fabio Colonna** - [fabcolonna](https://github.com/fabcolonna)

## License

ProxLock is under the MIT License.

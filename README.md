# Swift

This is a Swift engine used to launch Swift apps on [Nanobox](http://nanobox.io).

## Usage
To use the Swift engine, specify `swift` as your `engine` in your `boxfile.yml`.

```yaml
run.config:
  engine: swift
```

## Build Process
When [building your runtime](https://docs.nanobox.io/cli/build-runtime), this engine compiles code by doing the following:

* `swift build --configuration release`

*This command can be modified using the [build](#build) config option.*

## Configuration Options
This engine exposes configuration options through the [boxfile.yml](https://docs.nanobox.io/boxfile), a YAML config file used to provision and configure your app's infrastructure when using Nanobox. This engine makes the following options available.

#### Overview of Boxfile Configuration Options
```yaml
run.config:
  engine: swift
  engine.config:
    # Swift settings
    runtime: swift-4.0
    build: 'swift build --configuration release'
```

---

#### runtime
Specifies which Swift runtime to use. The following runtimes are available:

- swift-4.0 *(default)*

```yaml
run.config:
  engine: swift
  engine.config:
    runtime: swift-4.0
```

---

#### build
Defines the command to run to compile your code in the build process.

```yaml
run.config:
  engine: swift
  engine.config:
    build: 'swift build'
```

---

## TODO
- Install Swift dependencies `clang` and `libicu-dev` properly
- Add Swift binaries to $PATH properly
- Write tests

# CodeExpert Shared Library Creation

A short guide on creating shared libraries compatible with ETH's [CodeExpert](http://expert.ethz.ch/) using Rust and the [JNI](https://en.wikipedia.org/wiki/Java_Native_Interface).

## Before you start:

- CodeExpert only allows file uploads up to 2MB. If your library requires many dependencies, it may be too large. You may have success in optimizing the program for size and stripping the binary.
- This guide will rely on the JNI; however, it should be possible to generalize.
- :warning: Do not use shared libraries in your exercises. You risk losing your points.



## Creating the library

1. Write your Java class, define native methods.

2. Generate C headers.

   ```bash
   $ javac JavaTemplate/src/LibMath.java -h .
   ```

   This will generate a C header file that specifies the method names, parameters, and return values. The syntax can be easily translated into Rust (see example). `lib.rs` should include functions that look like this:

   ```rust
   #[no_mangle]
   pub extern "system" fn <methodName>(_env: JNIEnv, ...) -> ... {
       ...
   }
   ```

3. Write your library code. Get rusty :crab:



## Compiling

CodeExpert runs in a virtualized container, which is an `x86-64 GNU` system. Therefore, the target platform for Rust compilation should be set as `x86-64_unknown_linux_gnu`.

#### The Crux

CodeExpert probably does not use the same `glibc` version as you have on your computer. You can verify this by running `lld --version` in your terminal. As of 2023, CX uses version `2.28`.

`glibc` is somewhat backwards compatible, so you must compile with an earlier or equal version of `glibc` installe don your computer.

To make the process slightly easier, you can use the `.dockerfile` to set up a container that runs the correct `glibc` version. Now you can compile your program.

```bash
$ cargo build --release
```

After compiling in the Docker container, you can copy the library out of the container back to your machine. You may want to `strip` the binary, as they can turn out to be quite large.

```bash
$ strip LibMath.so
```



## Using the library in CX

Create a new empty file called `LibMath.so`. Now you can drag and drop the binary, uploading it to CodeExpert.

You can load the library into Java using:

```java
class Main{
    ...
    static {
        System.load("/absolute/path/to/the/shared/library/LibMath.so");
    }
}
```

The absolute path depends on how your tutor set up the environment, but that is easy enough to figure out.

Remember to also include the class from which you created the library. 

```java
public class LibMath {
    public static native int add(int a, int b);
}
```

Your program should run now. Everything else can be googled.

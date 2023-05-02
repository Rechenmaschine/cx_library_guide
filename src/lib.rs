use jni::JNIEnv;
use jni::sys::jint;

#[no_mangle]
pub extern "system" fn Java_LibMath_add(_env: JNIEnv, a: jint, b: jint) -> jint {
    return a + b;
}
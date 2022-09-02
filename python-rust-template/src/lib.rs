use pyo3::prelude::*;
use pyo3::exceptions::{PyValueError, PyOverflowError};

/// Finds the nth Fibonacci number
#[pyfunction]
fn fib(n: &PyAny) -> PyResult<usize> {
    let n = n.extract::<isize>()?;

    match n {
        0 => Ok(1),
        1 => Ok(1),
        _ if n < 0 => Err(PyValueError::new_err("Fibonacci cannot take negative numbers")),
        _ => {
            let mut a: usize = 0;
            let mut b: usize = 1;

            for _ in 1..n {
                let tmp = a;
                a = b;
                b = a.checked_add(tmp).ok_or(PyOverflowError::new_err("Overflow occured when calculating Fibonacci"))?;
            }

            Ok(b)
        }
    }
}

#[pymodule]
fn package_name(_py: Python<'_>, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(fib, m)?)?;
    Ok(())
}

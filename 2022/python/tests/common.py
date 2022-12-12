import functools


def highlight(test_func):
    @functools.wraps(test_func)
    def wrapper(*arg, **kwargs):
        print("")
        print("---- Highlighted -------------")
        test_func(*arg, **kwargs)
        print("------------------------------")
        assert False, "No Failure, just highlighting"

    return wrapper

class Color:
    RED     = 31
    GREEN   = 32
    YELLOW  = 33
    BLUE    = 34
    MAGENTA = 35
    CYAN    = 36

def colorize(text, color_code):
    return f"\033[{color_code}m{text}\033[0m"

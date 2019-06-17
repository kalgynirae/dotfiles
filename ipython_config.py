from IPython.terminal.prompts import Prompts
from pygments.style import Style
from pygments.token import Token

class AnsiStyle(Style):
    styles = {
        Token.Comment: "ansibrightblack",
        Token.Keyword: "ansired bold",
        Token.Literal: "ansibrightmagenta",
        Token.Literal.String: "ansiyellow",
        Token.Literal.String.Escape: "ansicyan italic",
        Token.Name.Decorator: "ansigreen",
    }

c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.highlighting_style = AnsiStyle

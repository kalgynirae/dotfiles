from IPython.terminal.prompts import Prompts
from pygments.style import Style
from pygments.token import Token

class AnsiStyle(Style):
    styles = {
        Token.Comment: "#ansidarkgray",
        Token.Keyword: "#ansidarkred bold",
        Token.Literal: "#ansifuchsia",
        Token.Literal.String: "#ansibrown",
        Token.Literal.String.Escape: "#ansiteal italic",
        Token.Name.Decorator: "#ansidarkgreen",
    }

c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.highlighting_style = AnsiStyle

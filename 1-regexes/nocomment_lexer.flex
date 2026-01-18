%option noyywrap

%{

#include "nocomment.hpp"

// The following line avoids an annoying warning in Flex
// See: https://stackoverflow.com/questions/46213840/
extern "C" int fileno(FILE *stream);

int removed_count = 0;

%}

%x ATTRIBUTE

%%

\\[^ \t\n\r]+   { ECHO; }

"//".*\n { removed_count++; }

"(*" { removed_count++; BEGIN(ATTRIBUTE); }

. {
  yylval.character = yytext[0];
  return Other;
}

\n {
  yylval.character = '\n';
  return Other;
}

<ATTRIBUTE>{
  \\[^ \t\n\r]+ { ; }

  "//".* { ; }

  "*)" { BEGIN(INITIAL); }

  .|\n { ; }
}

EOF {
  return Eof;
}

%%

/* Error handler. This will get called if none of the rules match. */
void yyerror (char const *s)
{
  fprintf (stderr, "Flex Error: %s\n", s);
  exit(1);
}

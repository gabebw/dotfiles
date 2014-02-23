if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let b:current_syntax = "scala"

syn case match
syn sync minlines=200 maxlines=1000

syn keyword scalaKeyword catch do else final finally for forSome if
syn keyword scalaKeyword match return throw try while yield
syn keyword scalaKeyword class trait object extends with nextgroup=scalaInstanceDeclaration skipwhite
syn keyword scalaKeyword case nextgroup=scalaKeyword,scalaCaseFollowing skipwhite
syn keyword scalaKeyword val nextgroup=scalaNameDefinition,scalaQuasiQuotes skipwhite
syn keyword scalaKeyword def var nextgroup=scalaNameDefinition skipwhite
hi link scalaKeyword Keyword

syn match scalaSymbol /'[_A-Za-z0-9$]\+/
hi link scalaSymbol Number

syn match scalaChar /'.'/
syn match scalaEscapedChar /\\[\\ntbrf]/
syn match scalaUnicodeChar /\\u[A-Fa-f0-9]\{4}/
hi link scalaChar Character
hi link scalaEscapedChar Function
hi link scalaUnicodeChar Special

syn match scalaNameDefinition /\<[_A-Za-z0-9$]\+\>/ contained nextgroup=scalaPostNameDefinition
syn match scalaNameDefinition /`[^`]\+`/ contained nextgroup=scalaPostNameDefinition
syn match scalaPostNameDefinition /\_s*:\_s*/ contained nextgroup=scalaTypeDeclaration
hi link scalaNameDefinition Function

syn match scalaInstanceDeclaration /\<[_\.A-Za-z0-9$]\+\>/ contained
syn match scalaInstanceDeclaration /`[^`]\+`/ contained
hi link scalaInstanceDeclaration Special

" Handle type declarations specially
syn region scalaTypeStatement matchgroup=Keyword start=/\<type\_s\+\ze/ end=/$/ contains=scalaTypeTypeDeclaration,scalaSquareBrackets,scalaTypeTypeEquals

" Ugh... duplication of all the scalaType* stuff to handle special highlighting
" of `type X =` declarations
syn match scalaTypeTypeDeclaration /(/ contained nextgroup=scalaTypeTypeExtension,scalaTypeTypeEquals contains=scalaRoundBrackets skipwhite
syn match scalaTypeTypeDeclaration /\%(⇒\|=>\)\ze/ contained nextgroup=scalaTypeTypeDeclaration contains=scalaTypeTypeExtension skipwhite
syn match scalaTypeTypeDeclaration /\<[_\.A-Za-z0-9$]\+\>/ contained nextgroup=scalaTypeTypeExtension,scalaTypeTypeEquals skipwhite
syn match scalaTypeTypeEquals /=\ze[^>]/ contained nextgroup=scalaTypeTypePostDeclaration skipwhite
syn match scalaTypeTypeExtension /)\?\_s*\zs\%(⇒\|=>\|<:\|:>\|=:=\|::\)/ contained nextgroup=scalaTypeTypeDeclaration skipwhite
syn match scalaTypeTypePostDeclaration /\<[_A-Za-z0-9$]\+\>/ contained nextgroup=scalaTypeTypePostExtension contains=ALLBUT,scalaParamAnnotationValue skipwhite
syn match scalaTypeTypePostExtension /\%(⇒\|=>\|<:\|:>\|=:=\|::\)/ contained nextgroup=scalaTypeTypePostDeclaration skipwhite
hi link scalaTypeTypeDeclaration Type
hi link scalaTypeTypeExtension Keyword
hi link scalaTypeTypePostDeclaration Special
hi link scalaTypeTypePostExtension Keyword

syn match scalaTypeDeclaration /(/ contained nextgroup=scalaTypeExtension contains=scalaRoundBrackets skipwhite
syn match scalaTypeDeclaration /\%(⇒\|=>\)\ze/ contained nextgroup=scalaTypeDeclaration contains=scalaTypeExtension skipwhite
syn match scalaTypeDeclaration /\<[_\.A-Za-z0-9$]\+\>/ contained nextgroup=scalaTypeExtension skipwhite
syn match scalaTypeExtension /)\?\_s*\zs\%(⇒\|=>\|<:\|:>\|=:=\|::\)/ contained nextgroup=scalaTypeDeclaration skipwhite
hi link scalaTypeDeclaration Type
hi link scalaTypeExtension Keyword
hi link scalaTypePostExtension Keyword

syn match scalaTypeAnnotation /\%([_a-zA-Z0-9$\s]:\_s*\)\ze[_=(\.A-Za-z0-9$]\+/ skipwhite nextgroup=scalaTypeDeclaration contains=scalaRoundBrackets
syn match scalaTypeAnnotation /)\_s*:\_s*\ze[_=(\.A-Za-z0-9$]\+/ skipwhite nextgroup=scalaTypeDeclaration
hi link scalaTypeAnnotation Normal

syn match scalaCaseFollowing /\<[_\.A-Za-z0-9$]*\>/ contained
syn match scalaCaseFollowing /`[^`]\+`/ contained
hi link scalaCaseFollowing Special

syn keyword scalaKeywordModifier abstract override final lazy implicit private protected sealed null require super
hi link scalaKeywordModifier Function

syn keyword scalaSpecial this true false package import
syn keyword scalaSpecial new nextgroup=scalaInstanceDeclaration skipwhite
syn match scalaSpecial "\%(=>\|⇒\|<-\|←\|->\|→\)"
syn match scalaSpecial /`[^`]*`/  " Backtick literals
hi link scalaSpecial PreProc

syn match scalaStringEmbeddedQuote /\\"/ contained
syn region scalaString start=/"/ end=/"/ contains=scalaStringEmbeddedQuote,scalaEscapedChar,scalaUnicodeChar
hi link scalaString String
hi link scalaStringEmbeddedQuote String

syn region scalaSString matchgroup=Special start=/s"/ skip=/\\"/ end=/"/ contains=scalaInterpolation,scalaEscapedChar,scalaUnicodeChar
syn match scalaInterpolation /\$[a-zA-Z0-9_$]\+/ contained
syn match scalaInterpolation /\${[^}]\+}/ contained
hi link scalaSString String
hi link scalaInterpolation Function

syn region scalaFString matchgroup=Special start=/f"/ skip=/\\"/ end=/"/ contains=scalaInterpolation,scalaFInterpolation,scalaEscapedChar,scalaUnicodeChar
syn match scalaFInterpolation /\$[a-zA-Z0-9_$]\+%[-A-Za-z0-9\.]\+/ contained
syn match scalaFInterpolation /\${[^}]\+}%[-A-Za-z0-9\.]\+/ contained
hi link scalaFString String
hi link scalaFInterpolation Function

syn region scalaQuasiQuotes matchgroup=Type start=/\<q"/ skip=/\\"/ end=/"/ contains=scalaInterpolation
syn region scalaQuasiQuotes matchgroup=Type start=/\<[tcp]q"/ skip=/\\"/ end=/"/ contains=scalaInterpolation
hi link scalaQuasiQuotes String

syn region scalaTripleQuasiQuotes matchgroup=Type start=/\<q"""/ end=/"""\%([^"]\|$\)/ contains=scalaInterpolation
syn region scalaTripleQuasiQuotes matchgroup=Type start=/\<[tcp]q"""/ end=/"""\%([^"]\|$\)/ contains=scalaInterpolation
hi link scalaTripleQuasiQuotes String

syn region scalaTripleString start=/"""/ end=/"""\%([^"]\|$\)/ contains=scalaEscapedChar,scalaUnicodeChar
syn region scalaTripleSString matchgroup=Special start=/s"""/ end=/"""\%([^"]\|$\)/ contains=scalaInterpolation,scalaEscapedChar,scalaUnicodeChar
syn region scalaTripleFString matchgroup=Special start=/f"""/ end=/"""\%([^"]\|$\)/ contains=scalaInterpolation,scalaFInterpolation,scalaEscapedChar,scalaUnicodeChar
hi link scalaTripleString String
hi link scalaTripleSString String
hi link scalaTripleFString String

syn match scalaNumber /\<0[dDfFlL]\?\>/ " Just a bare 0
syn match scalaNumber /\<[1-9]\d*[dDfFlL]\?\>/  " A multi-digit number - octal numbers with leading 0's are deprecated in Scala
syn match scalaNumber /\<0[xX][0-9a-fA-F]\+[dDfFlL]\?\>/ " Hex number
syn match scalaNumber /\%(\<\d\+\.\d*\|\.\d\+\)\%([eE][-+]\=\d\+\)\=[fFdD]\=/ " exponential notation 1
syn match scalaNumber /\<\d\+[eE][-+]\=\d\+[fFdD]\=\>/ " exponential notation 2
syn match scalaNumber /\<\d\+\%([eE][-+]\=\d\+\)\=[fFdD]\>/ " exponential notation 3
hi link scalaNumber Number

syn region scalaRoundBrackets start="(" end=")" skipwhite contained contains=scalaTypeDeclaration,scalaSquareBrackets,scalaRoundBrackets

syn region scalaSquareBrackets matchgroup=Type start="\[" end="\]" skipwhite nextgroup=scalaTypeExtension contains=scalaTypeDeclaration,scalaSquareBrackets,scalaTypeOperator,scalaTypeAnnotationParameter
syn match scalaTypeOperator /[-+=:<>]\+/ contained
syn match scalaTypeAnnotationParameter /@\<[`_A-Za-z0-9$]\+\>/ contained
hi link scalaTypeOperator Keyword
hi link scalaTypeAnnotationParameter Function

syn region scalaMultilineComment start="/\*" end="\*/" contains=scalaMultilineComment,scalaDocLinks,scalaParameterAnnotation,scalaCommentAnnotation,scalaCommentCodeBlock,@scalaHtml keepend
syn match scalaCommentAnnotation "@[_A-Za-z0-9$]\+" contained
syn match scalaParameterAnnotation "@param" nextgroup=scalaParamAnnotationValue skipwhite contained
syn match scalaParamAnnotationValue /[`_A-Za-z0-9$]\+/ contained
syn region scalaDocLinks start="\[\[" end="\]\]" contained
syn region scalaCommentCodeBlock matchgroup=Keyword start="{{{" end="}}}" contained
hi link scalaMultilineComment Comment
hi link scalaDocLinks Function
hi link scalaParameterAnnotation Function
hi link scalaParamAnnotationValue Keyword
hi link scalaCommentAnnotation Function
hi link scalaCommentCodeBlock String

syn match scalaAnnotation /@\<[`_A-Za-z0-9$]\+\>/
hi link scalaAnnotation PreProc

syn match scalaTrailingComment "//.*$"
hi link scalaTrailingComment Comment

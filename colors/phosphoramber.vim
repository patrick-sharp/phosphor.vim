" Phosphor Amber
" Based on old amber monochrome CRT monitors
" 
" this ex command is useful to figuring out what highlight group is applied to
" a given character: echo synIDattr(synID(line('.'), col('.'), 1), 'name')
"
" also, for most higlight groups, you can look them up with the help command.
" e.g. :h StatusLineNC
" 
" Rules of thumb:
"   cursorline, line numbers, and status line should be very faint
"     but status line should not be so faint that it's hard to tell where the split between two windows is
"   types should be slightly less prominent than normal text
"   language keywords should be slightly more prominent than normal text
"   strings should be more prominent than language keywords
"   constants (booleans/nulls/numbers) should be more prominent than strings, and in a contrasting hue with the background
"   comments should be very prominent, and in a contrasting hue with the background
"   delimiters and operators should be the same as normal text.
"     I'm a bit on the fence about this, but ultimately graying them out makes
"     operators disappear, and muddies the water between different kinds of
"     delimiters.
"   Avoid different type effects (bold/underline etc.), it ruins the flow when reading.
"     There are some exceptions to this:
"     Comments, which I find I like to have italicized to make them stand out.
"     Bold/italic/underline types in markdown.
"
" Things to check:
"   all the languages in the code folder
"   wildmenu (the file completion menu in the command line, press :e ./<tab>)
"   tabline (run :tabnew)
"   qflist (run :copen after running a vimgrep command. google vimgrep if you don't know how)
"   popup menu or pmenu (enter insert mode and hit ctrl-n)
"   visual selection
"   cursor column (run :set cursorcolumn)
"   cursor line (run :set cursorline)
"   listchars (run :set list)
"   folds (type zf with a few lines selected in visual mode to make a fold. zo to open fold)
"   foldcolumn (run :set foldcolumn=2, then make a fold)
"   search (run :set hlsearch)
"   signcolumn (run :set signcolumn=yes)
"   spellcheck (run :setlocal spell spelllang=en_us, run :set nospell to disable)
"     for undercurl to work properly, you do need to have undercurl support set properly in vimrc:
"     let &t_Cs = "\e[4:3m"
"     let &t_Ce = "\e[4:0m"
"   diff (run :vert diffsplit otherfile.txt, close the other window to end diff view)
"   Quickfix list 
"     :call setqflist([{'bufnr': bufnr(), 'lnum': 1}, {'bufnr': bufnr(), 'lnum': 2}]) | copen

let g:colors_name = "phosphoramber"

" Monochromatic colors
" I base my color schemes around a dark background color.
" The monochromatic colors are all colors between that background and white.
" The darker colors are used for backgrounds and UI elements. The lighter colors
" are used for accentuated elements
let s:mono_1           = "#000000" " Background
let s:mono_2           = "#222222" " Cursor line      - Background color of elements that slightly stand out from background 
let s:mono_3           = "#333333" " Visual Selection - Background color of elements that stand out from background          
let s:mono_4           = "#3a3a3a" " listchars        - Text color of elements that stand out from background                
let s:mono_5           = "#4a4a4a" " line numbers     - Text color for text that stands out from the background              
let s:mono_6           = "#7e7e7e" " CursorLineNr     - Text color that stands out against faint_gray_light
let s:mono_7           = "#B8B8B8" " Strings          - Accentuated elements
let s:mono_8           = "#EEEEEE" " Comments         - Very accentuated elements

" Multichromatic colors
" The multichromatic colors are meant to stand out against the monochromatic colors.
let s:amber          = "#ffa500" " Normal text
let s:red            = "#ff4757" " Red - used for errors only.
let s:yellow         = "#ffcb6b" " Warm yellow
let s:diff_add_bg    = "#1a5228" " Faint green
let s:diff_delete_bg = "#52191f" " Faint red
let s:diff_change_bg = "#52451a" " Faint yellow

" Loud elements
let s:string             = s:mono_7
let s:constant           = s:mono_7
let s:comment            = s:mono_8
let s:keyword            = s:amber
let s:type               = s:amber
let s:normal_text        = s:amber
let s:error              = s:red
let s:warning            = s:yellow

" Helper function to set highlight groups
function! s:h(group, fg, bg, attr)
  let l:cmd = 'hi ' . a:group . ' guisp=NONE'
  if a:fg != ''
    let l:cmd .= ' guifg=' . a:fg
  endif
  if a:bg != ''
    let l:cmd .= ' guibg=' . a:bg
  endif
  if a:attr != ""
    let l:cmd .= " gui=" . a:attr . " cterm=" . a:attr
  else
    let l:cmd .= ' gui=NONE cterm=NONE'
  endif
  execute l:cmd
endfunction

" Helper function to clear highlight groups. for some reason, the Type highlight group was still set to green even if I didn't explicitly set it in in this file.
function! s:clear(group)
  execute 'hi clear ' . a:group
endfunction

if !&termguicolors
  echo "termguicolors is OFF, please run set termguicolors in order to use this colorscheme properly"
endif

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

" UI Elements
" Roughly arranged darkest to lightest, although exceptions are made to
" colocate related groups.
call s:h("VertSplit",    s:mono_2,      "",            ""    )
call s:h("LineNr",       s:mono_5,      s:mono_1,      ""    )
call s:h("Cursor",       s:mono_1,      s:normal_text, ""    ) " Note: This doesn't do anything in terminal vim since the terminal emulator controls the cursor shape/color
call s:h("CursorLine",   "NONE",        s:mono_2,      ""    )
call s:h("CursorColumn", "NONE",        s:mono_2,      ""    )
call s:h("Visual",       "NONE",        s:mono_3,      ""    )
call s:h("VisualNOS",    "NONE",        s:mono_3,      ""    )
call s:h("SpecialKey",   s:mono_4,      "",            ""    ) " listchars
call s:h("NonText",      s:mono_4,      "",            ""    )
call s:h("Whitespace",   s:mono_4,      "",            ""    )
call s:h("EndOfBuffer",  s:mono_4,      "",            ""    )
call s:h("Conceal",      s:mono_4,      "",            ""    )
call s:h("Pmenu",        s:normal_text, s:mono_3,      ""    )
call s:h("PmenuSbar",    "",            s:mono_5,      ""    )
call s:h("PmenuThumb",   "",            s:mono_7,      ""    )
call s:h("CursorLineNr", s:mono_6,      "NONE",        ""    )
call s:h("Search",       s:mono_1,      s:mono_7,      ""    )
call s:h("IncSearch",    s:mono_1,      s:mono_7,      ""    )
call s:h("Normal",       s:normal_text, s:mono_1,      ""    )
call s:h("SignColumn",   s:normal_text, s:mono_1,      ""    )
call s:h("Quickfix",     s:normal_text, s:mono_1,      ""    )
call s:h("WildMenu",     s:normal_text, s:mono_1,      ""    )
call s:h("Directory",    s:normal_text, s:mono_1,      ""    )
call s:h("TablineFill",  "",            s:normal_text, ""    )
call s:h("Tabline",      s:mono_1   ,   s:normal_text, ""    )
call s:h("Folded",       s:mono_1,      s:normal_text, ""    )
call s:h("FoldColumn",   s:mono_1,      s:normal_text, ""    )
call s:h("StatusLine",   s:mono_1,      s:normal_text, ""    )
call s:h("StatusLineNC", s:mono_1,      s:normal_text, ""    )
call s:h("PmenuSel",     s:mono_1,      s:normal_text, ""    )
call s:h("qfLineNr",     s:mono_7,      "NONE",        ""    )
call s:h("MatchParen",   s:mono_8,      "NONE",        "bold")

" Diff
call s:h("DiffAdd",     "NONE", s:diff_add_bg,    "")
call s:h("DiffDelete",  "NONE", s:diff_delete_bg, "")
call s:h("DiffText",    "NONE", s:diff_change_bg, "")
call s:h("DiffTextAdd", "NONE", s:diff_add_bg,    "")
call s:clear("DiffChange")

" Messages
call s:h("Error",      s:error,   "NONE", "bold")
call s:h("ErrorMsg",   s:error,   "NONE", "bold")
call s:h("WarningMsg", s:warning, "",     ""    )
call s:h("MoreMsg",    s:string,  "",     ""    )
call s:h("Question",   s:string,  "",     ""    )

" Syntax Highlighting
call s:h("Comment",        s:comment,     "",     "italic")
call s:h("SpecialComment", s:constant,    "",     "italic") " These are supposed to be for javadoc/jsdoc/ things like that, but no languages I look at seem to do that.
call s:h("Todo",           s:constant,    "NONE", "bold"  ) " A small set of comments like TODO, FIXME etc.
call s:h("Constant",       s:constant,    "",     ""      )
call s:h("Number",         s:constant,    "",     ""      )
call s:h("Boolean",        s:constant,    "",     ""      )
call s:h("Float",          s:constant,    "",     ""      )
call s:h("String",         s:string,      "",     ""      )
call s:h("Character",      s:string,      "",     ""      )
call s:h("Type",           s:type,        "",     ""      )
call s:h("Statement",      s:keyword,     "",     ""      )
call s:h("Conditional",    s:keyword,     "",     ""      )
call s:h("Repeat",         s:keyword,     "",     ""      )
call s:h("Label",          s:keyword,     "",     ""      )
call s:h("Keyword",        s:keyword,     "",     ""      )
call s:h("Exception",      s:keyword,     "",     ""      )
call s:h("Identifier",     s:normal_text, "",     ""      )
call s:h("Operator",       s:normal_text, "",     ""      )

" PreProc
call s:h("PreProc",   s:normal_text, "", "")
call s:h("Include",   s:keyword,     "", "")
call s:h("Macro",     s:normal_text, "", "")
call s:h("PreCondit", s:normal_text, "", "")
call s:h("Define",    s:keyword,     "", "")

" Special
call s:h("Special",     s:keyword, "", "")
call s:h("SpecialChar", s:string,  "", "")
call s:h("Tag",         s:keyword, "", "")
call s:h("Debug",       s:keyword, "", "")

" Underlined & Errors
call s:h("Underlined", s:string,  "", "underline")
call s:h("Error",      s:error,   "", "bold"     )
call s:h("SpellBad",   s:error,   "", "undercurl")
call s:h("SpellCap",   s:warning, "", "undercurl")

" Misc
call s:h("StorageClass", s:keyword, "", "")
call s:clear("Title")

" Language-Specific Enhancements

" Python
" unfortunately, there doesn't seem to be a highlight group for just multiline strings
call s:h("pythonBuiltin",       s:normal_text, "", "")
call s:h("pythonDecoratorName", s:normal_text, "", "")
call s:h("pythonStatement",     s:keyword,     "", "")

" Vim script
call s:h("vimCommand", s:keyword, "", "")
call s:h("vimLet",     s:keyword, "", "")

" HTML/XML
call s:h("htmlTag",         s:keyword,     "", "")
call s:h("htmlEndTag",      s:keyword,     "", "")
call s:h("htmlTagName",     s:keyword,     "", "")
call s:h("htmlArg",         s:normal_text, "", "")
call s:h("htmlSpecialChar", s:keyword,     "", "")

" CSS
call s:h("cssClassName",  s:keyword, "", "")

" Markdown
call s:h("markdownHeadingDelimiter", s:comment, "", "bold"       )
call s:h("markdownH1",               s:comment, "", "bold"       )
call s:h("markdownH2",               s:comment, "", "bold"       )
call s:h("markdownH3",               s:comment, "", "bold"       )
call s:h("markdownH4",               s:comment, "", "bold"       )
call s:h("markdownH5",               s:comment, "", "bold"       )
call s:h("markdownH6",               s:comment, "", "bold"       )
call s:h("markdownBold",             s:keyword, "", "bold"       )
call s:h("markdownItalic",           s:keyword, "", "italic"     )
call s:h("markdownBoldItalic",       s:keyword, "", "bold,italic")
call s:h("markdownCode",             s:string,  "", ""           )
call s:h("markdownCodeBlock",        s:string,  "", ""           )
call s:h("markdownUrl",              s:string,  "", "underline"  )
call s:h("markdownLinkText",         s:keyword, "", ""           )

" Objective-C
call s:h("objcObjDef",   s:keyword, "", "") " @end
call s:h("objcProtocol", s:keyword, "", "") " @protocol
call s:h("objcPool",     s:keyword, "", "") " @autoreleasepool


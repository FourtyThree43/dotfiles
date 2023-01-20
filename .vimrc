set tabstop=2 shiftwidth=2
set autoindent
set smartindent
set cindent

syntax enable
set number
set relativenumber

autocmd Bufwritepre * :%s/\s\+$//e

let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme desert

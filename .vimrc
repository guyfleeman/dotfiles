set scrolloff=5

set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
augroup END

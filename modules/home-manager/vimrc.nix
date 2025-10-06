{ ... }:
{
  home.file = {
    ".ideavimrc" = {
      text = ''
        set scrolloff=10
        set linenumber
        set relativenumber
        set showmode
        set showcmd
        set visualbell


        set ignorecase
        set smartcase
        set incsearch
        set hlsearch
        set clipboard=unnamedplus

        let mapleader = " "

        " Plugins
        set surround
        set highlightedyank
        set sneak
        set nerdtree
        set easymotion
        set commentary
        set notimeout
        set which-key
        set quickscope

        " Idea settings
        set ideajoin
        set ideavimsupport=singleline


        " let g:WhichKeyDesc_<identifier> = "<keybinding> <helptext>"

        let g:WhichKeyDesc_next = "] Next"
        let g:WhichKeyDesc_prev = "[ Previous"
        let g:WhichKeyDesc_next_error = "]d Next error"
        let g:WhichKeyDesc_prev_error = "[d Previous error"
        let g:WhichKeyDesc_next_change = "]c Next git change"
        let g:WhichKeyDesc_prev_change = "[c Previous git change"
        let g:WhichKeyDesc_next_find = "]q Next find occurence"
        let g:WhichKeyDesc_prev_finc = "[q Previous find occurence"
        let g:WhichKeyDesc_display = "<leader>z Display options"
        let g:WhichKeyDesc_df_mode = "<leader>zd Toggle Distraction-Free mode"
        let g:WhichKeyDesc_zen_mode = "<leader>zz Toggle Zen mode"
        let g:WhichKeyDesc_fullscreen = "<leader>zf Toggle full screen"
        let g:WhichKeyDesc_file_nav = "<leader>f File navigation"
        let g:WhichKeyDesc_file_nav_goto_file = "<leader>ff Go to file"
        let g:WhichKeyDesc_file_nav_search_everywhere = "<leader>fF Search Everywhere"
        let g:WhichKeyDesc_file_nav_grep = "<leader>fg Search for file content"
        let g:WhichKeyDesc_switcher = "<leader><leader> Switcher"
        let g:WhichKeyDesc_file_nav_show_recent_locations = "<leader>fl Show recent locations"
        let g:WhichKeyDesc_actions = "<A-x> Actions"
        let g:WhichKeyDesc_refactoring = "<leader>r Refactoring menu"
        let g:WhichKeyDesc_refactoring_rename = "<leader>rn Rename element"
        let g:WhichKeyDesc_refactoring_method = "<leader>rm Extract method"
        let g:WhichKeyDesc_refactoring_variable = "<leader>rv Introduce variable"
        let g:WhichKeyDesc_refactoring_field = "<leader>rf Introduce field"
        let g:WhichKeyDesc_refactoring_signature = "<leader>rs Change signature"
        let g:WhichKeyDesc_refactoring_all = "<leader>rr Open refactorings list"
        let g:WhichKeyDesc_goto = "g Go to X"
        let g:WhichKeyDesc_goto_declaration = "gd Go to Definition"
        let g:WhichKeyDesc_goto_type_declaration = "gy Go to Type Definition"
        let g:WhichKeyDesc_goto_implementation = "gi Go to Implementation"
        let g:WhichKeyDesc_goto_usages = "gD Go to Usages"
        let g:WhichKeyDesc_goto_test = "gt Go to Test"
        let g:WhichKeyDesc_git = "<leader>g Git operations"
        let g:WhichKeyDesc_git_commit = "<leader>gc Open Git commit dialog"
        let g:WhichKeyDesc_git_status = "<leader>gs Open Git status dialog"
        let g:WhichKeyDesc_git_branches = "<leader>gb Open Git branches list"
        let g:WhichKeyDesc_git_reset = "<leader>gr Git reset lines"
        let g:WhichKeyDesc_debug = "<leader>d Debug"
        let g:WhichKeyDesc_debug_breakpoint = "<leader>db Breakpoint"
        let g:WhichKeyDesc_debug_cond_breakpoint = "<leader>dB Conditional breakpoint"
        let g:WhichKeyDesc_debug_run_debug = "<leader>dd Run Debug"
        let g:WhichKeyDesc_debug_cond_breakpoint = "<leader>dd Debug current"
        let g:WhichKeyDesc_project = "<leader>p Project"
        let g:WhichKeyDesc_project_run = "<leader>pr Run"
        let g:WhichKeyDesc_project_stop = "<leader>ps Run"
        let g:WhichKeyDesc_project_debug = "<leader>pd Debug"
        let g:WhichKeyDesc_error = "<leader>e Show error"
        let g:WhichKeyDesc_close = "<leader>q Hide active window"
        let g:WhichKeyDesc_F = "<leader>fluF Format file"
        let g:WhichKeyDesc_comment_current = "gcc Comment current line"
        let g:WhichKeyDesc_comment = "gc Comment "
        let g:WhichKeyDesc_comment_current = "gcc Comment current line"

        nmap ]d <Action>(GotoNextError)
        nmap [d <Action>(GotoPreviousError)
        nmap ]c <Action>(VcsShowNextChangeMarker)
        nmap [c <Action>(VcsShowPrevChangeMarker)
        nmap ]q <Action>(NextOccurence)
        nmap [q <Action>(PreviousOccurence)
        map <leader>zd <action>(ToggleDistractionFreeMode)
        map <leader>zz <action>(ToggleZenMode)
        map <leader>zf <action>(ToggleFullScreen)
        map <leader>ff <action>(GotoFile)
        map <leader>fF <action>(SearchEverywhere)
        map <leader>fg <action>(FindInPath)
        map <leader><leader> <Action>(Switcher)
        map <leader>fl <action>(RecentLocations)
        map <leader>fs <action>(NewScratchFile)
        map <A-x> <action>(GotoAction)
        map <leader>rn <Action>(RenameElement)
        map <leader>rm <Action>(ExtractMethod)
        map <leader>rv <Action>(IntroduceVariable)
        map <leader>rf <Action>(IntroduceField)
        map <leader>rs <Action>(ChangeSignature)
        map <leader>rr <Action>(Refactorings.QuickListPopupAction)
        nmap gd <Action>(GotoDeclaration)
        nmap gy <Action>(GotoTypeDeclaration)
        nmap gi <Action>(GotoImplementation)
        nmap gD <Action>(ShowUsages)
        nmap gt <Action>(GotoTest)
        map <leader>gc <Action>(CheckinProject)
        map <leader>gs <Action>(ActivateVersionControlToolWindow)
        map <leader>gb <Action>(Git.Branches)
        map <leader>gB <Action>(Annotate)
        map <leader>gr <Action>(Vcs.RollbackChangedLines)
        map <leader>db <Action>(ToggleLineBreakpoint)
        map <leader>dB <Action>(AddConditionalBreakpoint)
        map <leader>dd <Action>(DebugClass)
        map <leader>pr <Action>(RunClass)
        map <leader>ps <Action>(Stop)
        map <leader>pd <Action>(DebugClass)
        map <leader>e <Action>(ShowErrorDescription)
        map <leader>q <Action>(HideActiveWindow)
        map <leader>F :action ReformatCode<CR>:action OptimizeImports<CR>

        nxmap <leader>y "+y
        nxmap <leader>p "+p
        nmap <c-d> <c-d>zz
        nmap <c-u> <c-u>zz
        nmap n nzzzv
        nmap N Nzzzv
        nnoremap <esc> :noh<return><esc>
        nnoremap <A-h> <C-w>h
        nnoremap <A-l> <C-w>l
        nnoremap <A-k> <C-w>k
        nnoremap <A-j> <C-w>j
        command! Q close
        xnoremap > >gv
        xnoremap < <gv

        imap <A-p> <C-o>p
      '';
      executable = false;
    };
  };
}

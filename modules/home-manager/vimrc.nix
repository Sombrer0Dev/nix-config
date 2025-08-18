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


        " let g:WhichKeyDesc_<identifier> = "<keybinding> <helptext>"

        let g:WhichKeyDesc_display = "<leader>d Display options"
        let g:WhichKeyDesc_zen_mode = "<leader>dz Toggle Zen mode"
        let g:WhichKeyDesc_df_mode = "<leader>dd Toggle Distraction-Free mode"
        let g:WhichKeyDesc_fullscreen = "<leader>df Toggle full screen"

        let g:WhichKeyDesc_git = "<leader>g Git operations"
        let g:WhichKeyDesc_git_commit = "<leader>gc Open Git commit dialog"
        let g:WhichKeyDesc_git_status = "<leader>gs Open Git status dialog"
        let g:WhichKeyDesc_git_branches = "<leader>gb Open Git branches list"

        let g:WhichKeyDesc_refactoring = "<leader>r Refactoring menu"
        let g:WhichKeyDesc_refactoring_rename = "<leader>rn Rename element"
        let g:WhichKeyDesc_refactoring_method = "<leader>rm Extract method"
        let g:WhichKeyDesc_refactoring_variable = "<leader>rv Introduce variable"
        let g:WhichKeyDesc_refactoring_field = "<leader>rf Introduce field"
        let g:WhichKeyDesc_refactoring_signature = "<leader>rs Change signature"
        let g:WhichKeyDesc_refactoring_all = "<leader>rr Open refactorings list"
        let g:WhichKeyDesc_file_quickLook = "<leader><leader> Recent files"

        let g:WhichKeyDesc_file_nav = "<leader>f File navigation"
        let g:WhichKeyDesc_file_nav_goto_file = "<leader>ff Go to file"
        let g:WhichKeyDesc_file_nav_goto_file = "<leader>fF Search Everywhere"
        let g:WhichKeyDesc_file_nav_goto_file = "<leader><leader> Switcher"
        let g:WhichKeyDesc_file_nav_goto_content = "<leader>fc Search for file content"
        let g:WhichKeyDesc_file_nav_goto_file = "<leader>F NERD Tree"
        let g:WhichKeyDesc_file_nav_show_recent_files = "<leader>fr Show recent files"
        let g:WhichKeyDesc_file_nav_show_recent_locations = "<leader>fl Show recent locations"


        let g:WhichKeyDesc_goto = "g Go to X"
        let g:WhichKeyDesc_goto_declaration = "gd Go to Definition"
        let g:WhichKeyDesc_goto_type_declaration = "gy Go to Type Definition"
        let g:WhichKeyDesc_goto_implementation = "gi Go to Implementation"
        let g:WhichKeyDesc_goto_usages = "gD Go to Usages"
        let g:WhichKeyDesc_goto_test = "gt Go to Test"

        nmap ]d <Action>(GotoNextError)
        nmap [d <Action>(GotoPreviousError)
        nmap ]c <Action>(VcsShowNextChangeMarker)
        nmap [c <Action>(VcsShowPrevChangeMarker)
        map <leader>dd <action>(ToggleDistractionFreeMode)
        map <leader>dz <action>(ToggleZenMode)
        map <leader>df <action>(ToggleFullScreen)
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
        map <leader>grr <Action>(Vcs.RollbackChangedLines)
        map <leader>db <Action>(ToggleLineBreakpoint)
        map <leader>dB <Action>(AddConditionalBreakpoint)
        map <leader>pr <Action>(RunClass)
        map <leader>pd <Action>(DebugClass)
        map <leader>ps <Action>(Stop)
        map <leader>e <Action>(ShowErrorDescription)
        map <leader>q <Action>(HideActiveWindow)
        map <leader>F :action ReformatCode<CR>:action OptimizeImports<CR>

        nxmap <leader>y "+y
        nxmap <leader>p "+p
        nmap <c-d> <c-d>zz
        nmap <c-u> <c-u>zz
        nmap n nzzzv
        nmap N Nzzzv
        nnoremap <A-h> <C-w>h
        nnoremap <A-l> <C-w>l
        nnoremap <A-k> <C-w>k
        nnoremap <A-j> <C-w>j
      '';
      executable = false;
    };
  };
}

{ pkgs, ... }:
let
  bman = pkgs.writeShellScriptBin "bman" ''
    page=$(man -k . | fzf-tmux --nth 1,2)
    echo $page | awk 'BEGIN {ORS=" "}; {print $2} {print $1}'| tr -d '()' | xargs man
  '';
  # get-worktree-branch = pkgs.writeShellApplication {
  #   name = "get-worktree-branch";
  #   runtimeInputs = with pkgs; [
  #     git
  #     ripgrep
  #   ];
  #   text = ''
  #     if [ $# -eq 0 ]; then
  #       QUERY=""
  #     else
  #       QUERY="$1"
  #     fi
  #     git worktree list --porcelain | rg worktree | awk '{print $2}' | fzf --query "$QUERY" --select-1
  #   '';
  # };
  # delete-worktree-branch = pkgs.writeShellApplication {
  #   name = "delete-worktree-branch";
  #   runtimeInputs = with pkgs; [
  #     git
  #     ripgrep
  #   ];
  #   text = ''
  #     if [ $# -eq 0 ]; then
  #       QUERY=""
  #     else
  #       QUERY="$1"
  #     fi
  #     git worktree remove "$(git worktree list --porcelain | rg worktree | awk '{print $2}' | fzf --query "$QUERY" --select-1)"
  #   '';
  # };
  # add-worktree-branch = pkgs.writeShellApplication {
  #   name = "add-worktree-branch";
  #   runtimeInputs = with pkgs; [
  #     git
  #     ripgrep
  #   ];
  #   text = ''
  #     if [ $# -eq 0 ]; then
  #       QUERY=""
  #     else
  #       QUERY="$1"
  #     fi
  #
  #     BRANCH="$(git branch --format='%(refname:short)' |fzf --query "$QUERY" --select-1)"
  #     WORKTREE_PATH="$(git worktree list | rg bare | awk '{print $1}')";
  #     git worktree add "$WORKTREE_PATH/$BRANCH"
  #     echo "$WORKTREE_PATH/$BRANCH"
  #   '';
  # };

  tmux-tabs = pkgs.writeShellApplication {
    name = "tmux-tabs";
    text = ''
      set +u
      # If we're in SSH, use the host
      if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
          echo "$(whoami)@$(hostname -s)"
      else
          # Otherwise show only the current directory
          basename "$PWD"
      fi
    '';
  };
  connect = pkgs.writeShellApplication {
    name = "con";
    runtimeInputs = with pkgs; [
      fzf
      ripgrep
    ];
    text = ''
      CONNECTIONS_FILE="$HOME/.ssh/connections"
      QUERY=""
      GENERATE=false

      # Expand includes and extract Host entries
      generate_connections() {
      TMPFILE=$(mktemp)
      FILES="$HOME/.ssh/config"

      # Collect included files
      while IFS= read -r line; do
        case "$line" in
          Include*)
            PATTERNS=$(printf '%s\n' "$line" | cut -d' ' -f2-)
            for pattern in $PATTERNS; do
              for f in "$HOME/.ssh"/$pattern; do
                [ -f "$f" ] && FILES="$FILES $f"
              done
            done
            ;;
        esac
      done < "$HOME/.ssh/config"

      : > "$TMPFILE"  # clear tmpfile

      # Parse each file and extract Host and HostName pairs
      for file in $FILES; do
        [ -f "$file" ] || continue

        awk '
          $1 == "Host" {
            split($0, hnames, " ")
            delete hnames[1]
            for (i in hnames) {
              if (hnames[i] !~ /[*?]/) {
                host = hnames[i]
                in_host = 1
                hostname = ""
                next
              }
            }
          }
          in_host && $1 == "HostName" {
            hostname = $2
          }
          in_host && NF == 0 {
            if (host && hostname) print host, hostname
            in_host = 0
          }
          END {
            if (host && hostname) print host, hostname
          }
        ' "$file" >> "$TMPFILE"
      done

      # Merge and deduplicate
      [ -f "$CONNECTIONS_FILE" ] && cat "$CONNECTIONS_FILE" >> "$TMPFILE"
      sort -u "$TMPFILE" > "$CONNECTIONS_FILE"
      rm "$TMPFILE"

      echo "Merged host entries saved to $CONNECTIONS_FILE"
      exit 0
      }


      # Parse options
      while [ $# -gt 0 ]; do
        case "$1" in
          -f)
            CONNECTIONS_FILE="$2"
            shift 2
            ;;
          --generate)
            GENERATE=true
            shift
            ;;
          *)
            if [ -z "$QUERY" ]; then
              QUERY="$1"
            fi
            shift
            ;;
        esac
      done

      if $GENERATE; then
        generate_connections
      fi

      # Validate file
      if [ ! -f "$CONNECTIONS_FILE" ]; then
        echo "Error: File '$CONNECTIONS_FILE' does not exist."
        exit 1
      fi

      # Extract usable lines
      HOSTS=$(rg '^\s*[^#\s]+' "$CONNECTIONS_FILE")

      if [ -z "$HOSTS" ]; then
        echo "Error: No valid hosts found in '$CONNECTIONS_FILE'."
        exit 1
      fi

      # Add ANSI escape codes around the second word
      HOSTS_ANSI=$(echo "$HOSTS" | while read -r first second rest; do
        # If line has only two words, $rest will be empty
        # Wrap second word with medium gray ANSI code and reset code
        echo -e "''${first} \e[38;5;245m''${second}\e[0m ''${rest}"
      done)
      # Show all with fzf but match/filter only on first word
      SELECTED=$(printf "%s\n" "$HOSTS_ANSI" | fzf --prompt="Select host: " --query="$QUERY" --nth=1 --ansi --delimiter=" ")

      if [ -z "$SELECTED" ]; then
        echo "No host selected."
        exit 1
      fi

      # Extract host (first word)
      HOST=$(printf "%s\n" "$SELECTED" | awk '{print $1}')
      echo "Connecting to $HOST..."
      exec ssh "$HOST"
    '';
  };
in
{
  home.packages = [
    bman
    # rf
    # rfq
    # add-worktree-branch
    # delete-worktree-branch
    # get-worktree-branch
    tmux-tabs
    connect
  ];
}

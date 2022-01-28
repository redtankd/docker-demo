function fish_user_key_bindings
    fish_vi_key_bindings

    # Block the default prompt for vi mode
    function fish_mode_prompt; end

    # Alt + u  
    bind  \eu 'cdup'
    bind -M insert \eu 'cdup'

    function cdup
	  cd ..
	  echo
	  commandline -f repaint
    end
end

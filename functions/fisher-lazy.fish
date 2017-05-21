function fisher-lazy
    set -l config_home $XDG_CONFIG_HOME

    if test -z "$config_home"
        set config_home ~/.config
    end

    if test -z "$fish_config"
        set -g fish_config "$config_home/fish"
    end

    if test -z "$fisher_config"
        set -g fisher_config "$config_home/fisherman"
    end

    if test -z "$fish_path"
        set -g fish_path "$fish_config"
    end

    if test -z "$fisher_file"
        set -g fisher_file "$fish_path/fishfile"
    end

    set name $argv[1]
    set bases functions conf.d completions
    for base in $bases
        if test ! -d $fisher_config/$name/$base
            continue
        end

        for file in (ls $fisher_config/$name/$base)
            if test (readlink -f $fish_config/functions/$file) != $fisher_config/$name/functions/$file
                continue
            end
            rm $fish_config/$base/$file
        end
    end

    if test ! -e $argv[2]
        set argv $argv $name
    end
    for cmd in $argv
        __fisher_lazy_create_function $cmd $name > $fish_config/functions/$cmd.fish
    end
end

function __fisher_lazy_create_function
    set cmd $argv[1]
    set name $argv[2]
    echo 'function '$cmd'
        source $fisher_config/'$name'/{functions,conf.d,completions}/*.fish
        eval '$cmd' $argv
    end'
end

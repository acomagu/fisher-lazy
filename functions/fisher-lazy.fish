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

    set name $argv[1]
    set bases functions conf.d completions
    for base in $bases
        if test ! -d $fisher_config/$name/$base
            continue
        end

        for file in (ls $fisher_config/$name/$base/ | grep '.fish$')
            if test (readlink -f $fish_config/$base/$file) != $fisher_config/$name/$base/$file
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
        set -l config_home $XDG_CONFIG_HOME

        if test -z "$config_home"
            set config_home ~/.config
        end

        if test -z "$fisher_config"
            set -g fisher_config "$config_home/fisherman"
        end

        for path in $fisher_config/'$name'/{functions,conf.d,completions}/*.fish
            if string match -r \'/uninstall\\.fish$\' $path > /dev/null
                continue
            end
            source $path
        end
        eval '$cmd' $argv
    end'
end

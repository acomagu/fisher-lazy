function lazy
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

    set -e $argv[1]
    for cmd in $argv
        __fisher_lazy_create_function $cmd $name
    end
end

function __fisher_lazy_create_function
    set cmd $argv[1]
    set name $argv[2]
    eval '
        function '$cmd'
            source $fisher_config/'$name'/{functions,conf.d,completions}/*.fish
            eval '$cmd' $argv
        end'
end

function add_alias
    if test (count $argv) -ne 2
        echo "Usage: add_alias <name> <path>"
        return 1
    end

    set name $argv[1]
    set path $argv[2]

    set alias_cmd "alias $name 'cd $path'"
    eval $alias_cmd

    set -U fish_user_aliases $fish_user_aliases $alias_cmd
end

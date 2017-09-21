function start_in_own_folder() {
    path=`realpath "$1"`
    cd "${path%/*}"
    . "${path##*/}"
}

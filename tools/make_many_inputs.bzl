_BUILD_CONTENT = """\
filegroup(
    name = "everything",
    srcs = glob(["**/*.fake_input"]),
    visibility = ["//visibility:public"],
)
"""

def _impl(repository_ctx):
    repository_ctx.file(
        "WORKSPACE",
        """workspace(name = %s)\n""" % repr(repository_ctx.name),
    )

    repository_ctx.file("BUILD", _BUILD_CONTENT)

    files_per_dir = 1000
    dir_count = (repository_ctx.attr.count // files_per_dir)

    for i in range(1, dir_count + 1):
        for j in range(1, files_per_dir + 1):
            file_num = (i * files_per_dir) + j
            filename = "dir_%d/%d.fake_input" % (i, file_num)
            repository_ctx.file(filename, "%s" % filename)

make_many_inputs_repo = repository_rule(
    implementation = _impl,
    attrs = {
        "count": attr.int(mandatory = True),
    },
)

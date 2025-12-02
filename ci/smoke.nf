
if( !params.container ) {
    throw new IllegalArgumentException("Must pass --container with full image:tag")
}

process SMOKE_TEST {
    tag "${params.container}"

    container params.container

    publishDir "results/smoke", mode: 'copy', overwrite: true

    script:
    """
    set -euo pipefail

    echo "Running smoke test in container: ${params.container}"
    echo "Working directory: \$(pwd)"
    echo "User: \$(id -u):\$(id -g)" || true

    # Run user-defined command
    ${params.command}

    # Exercise basic IO to catch permission issues
    echo "test-ok" > smoke_output.txt
    ls -l
    """
}

workflow {
    main:
        SMOKE_TEST()
}

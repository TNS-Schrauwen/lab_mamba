
if( !params.localContainer ) {
    throw new IllegalArgumentException("Must pass --container with full image:tag")
}

process SMOKE_TEST {
    publishDir "results/smoke", mode: 'copy', overwrite: true

    output:
    path "smoke_output.txt", emit: smoke_output

    script:
    """
    set -euo pipefail

    # Run user-defined command
    ${params.command} > smoke_output.txt
    """
}

workflow {
    main:
        SMOKE_TEST()
        SMOKE_TEST.out.smoke_output.view { "Generated smoke output file: ${it}" }
}

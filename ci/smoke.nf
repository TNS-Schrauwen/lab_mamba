
if( !params.container) {
    throw new IllegalArgumentException("Must pass --container with full image:tag")
}

process SMOKE_TEST {
    container params.container
    shell = ['/bin/sh', '-euo', 'pipefail']

    publishDir "results/smoke", mode: 'copy', overwrite: true

    output:
    path "smoke_output.txt", emit: smoke_output

    script:
    """
     #!/bin/sh
    set -euo pipefail

    # Run user-defined command
    which wget > smoke_output.txt
    """
}

workflow {
    main:
        SMOKE_TEST()
        SMOKE_TEST.out.smoke_output.view { "Generated smoke output file: ${it}" }
}

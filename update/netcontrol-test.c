#include <stdio.h>
#include <stdlib.h>
#include <netcontrol/netcf.h>
#include <netcontrol/logger.h>


static void
log_func(const char *category, int priority,
         const char *func, const char *file,
         long long line, const char *msg, size_t len)
{
    printf("ncf message: %s\n", msg);
}


int main(int argc, char**argv)
{
    struct netcf *netcf;
    unsigned int ncf_flags = NETCF_IFACE_ACTIVE | NETCF_IFACE_INACTIVE;
    int ret = -1;
    int count;
    char **names = NULL;
    size_t i;

    nc_logger_redirect_to(log_func);

    /* open netcf */
    if (ncf_init(&netcf, NULL) != 0) {
        fprintf(stderr, "ncf_init failed\n");
        exit(1);
    }

    if ((count = ncf_num_of_interfaces(netcf, ncf_flags)) < 0) {
        fprintf(stderr, "ncf_num_of_interfaces failed\n");
        goto cleanup;
    }

    if (count == 0) {
        ret = 0;
        goto cleanup;
    }

    printf("ncf_num_of_interfaces returned %d interfaces\n", count);
    if ((names = calloc(count, sizeof(*(names)))) == NULL) {
        fprintf(stderr, "Failed to allocate memory for interface names\n");
        goto cleanup;
    }
    
    if ((count = ncf_list_interfaces(netcf, count, names, ncf_flags)) < 0) {
        fprintf(stderr, "ncf_list_interfaces failed\n");
        goto cleanup;
    }

    for (i = 0; i < count; i++) {
        struct netcf_if *iface;
        unsigned int flags = 0;

        iface = ncf_lookup_by_name(netcf, names[i]);
        if (!iface) {
            fprintf(stderr, "ncf_lookup_by_name failed for interface %s\n", names[i]);
            goto cleanup;
        }

        printf("Retrieved interface %s from netcontrol\n", names[i]);
        if (ncf_if_status(iface, &flags) < 0) {
            fprintf(stderr, "nct_if_status failed for interface %s\n", names[i]);
            ncf_if_free(iface);
            goto cleanup;
        }

        if (flags & NETCF_IFACE_ACTIVE)
            printf("Interface %s is active!\n", names[i]);
        else
            printf("Interface %s is not active!\n", names[i]);

        ncf_if_free(iface);
    }
    ret = 0;

cleanup:
    if (names && count > 0)
        for (i = 0; i < count; i++)
            free(names[i]);
    free(names);
    ncf_close(netcf);
    return ret;
}


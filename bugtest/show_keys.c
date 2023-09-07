/*
 *  gcc showkeys.c -oshowkeys -lssh2
 *
 */

#include <libssh2.h>
#include <libssh2_sftp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>

/* Replace the below details with the appropriate values */
#define HOST "10.xx.xx.xx"
#define PORT 22
#define USERNAME "logu"
#define PASSWORD "xxxxxx" 

int main(int argc, char *argv[]) {
    libssh2_init(0);

    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock == -1) {
        perror("socket");
        return 1;
    }

    struct sockaddr_in sin;
    sin.sin_family = AF_INET;
    sin.sin_port = htons(PORT);
    sin.sin_addr.s_addr = inet_addr(HOST);

    if (connect(sock, (struct sockaddr *)&sin, sizeof(struct sockaddr_in)) != 0) {
        perror("connect");
        return 1;
    }

    // Initialize libssh2 session and set socket
    LIBSSH2_SESSION *session;
    LIBSSH2_CHANNEL *channel;
    session = libssh2_session_init();
    libssh2_session_startup(session, sock);

    if (libssh2_userauth_password(session, USERNAME, PASSWORD) != 0) {
        fprintf(stderr, "Authentication failed\n");
        return 1;
    }

    // Retrieve and print negotiated algorithms
    const char *kex_algo = libssh2_session_methods(session, LIBSSH2_METHOD_KEX);
    const char *hostkey_algo = libssh2_session_methods(session, LIBSSH2_METHOD_HOSTKEY);
    const char *cipher_algo = libssh2_session_methods(session, LIBSSH2_METHOD_CRYPT_CS);
    const char *mac_algo = libssh2_session_methods(session, LIBSSH2_METHOD_MAC_CS);

    printf("Negotiated Key Exchange Algorithm: %s\n", kex_algo);
    printf("Negotiated Host Key Algorithm: %s\n", hostkey_algo);
    printf("Negotiated Cipher Algorithm: %s\n", cipher_algo);
    printf("Negotiated MAC Algorithm: %s\n", mac_algo);

    libssh2_channel_free(channel);
    libssh2_session_disconnect(session, "Disconnecting");
    libssh2_session_free(session);

    close(sock);
    libssh2_exit();

    return 0;
}

$ gcc myssh.c -omyssh -lssh2


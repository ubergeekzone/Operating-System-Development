
void main( void* mbd, unsigned int magic )
{
    /* write your kernel here */
    unsigned char *text_buf = (unsigned char *)0xB8000;
    char *hello_world = "Hello from ZIMx7!";
    int i;
    
    /* clear the screen */
    for ( i = 0; i < 80 * 25; ++i ) {
        text_buf[i * 2] = ' ';
        text_buf[i * 2 + 1] = 0x00;
    }
    
    /* print hello world */
    while ( *hello_world ) {
        *text_buf++ = *hello_world++;
        *text_buf++ = 0x0F; /* determines colours to display */
    }
}

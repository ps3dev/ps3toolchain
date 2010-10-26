// This is a very bare-bones crt1, required for linking an executable.
// SDKs should totally reimplement everything here.

int main(int, const char*[], const char*[]);
void exit(int);

void _init();
void _fini();

static const char* envp[] = { 0 };
const char** environ = envp;

int _initialize(int argc, const char* argv[])
{
	_init();
	int ret = main(argc, argv, envp);
	exit(ret);
	return ret;
}

void _exit(int status)
{
	_fini();
}

int close(int file) { return -1; }
int execve(char *name, char **argv, char **env) { return -1; }
int fork() { return -1; }
//int fstat(int file, struct stat *st) { return -1; }
int fstat(int file, void* st) { return -1; }
int getpid() { return 1; }
int isatty(int file) { return -1; }
int kill(int pid, int sig) { return -1; }
int link(char *old, char *new) { return -1; }
int lseek(int file, int ptr, int dir) { return -1; }
int open(const char *name, int flags, int mode) { return -1; }
int read(int file, char *ptr, int len) { return -1; }
//int stat(char *file, struct stat *st) { return -1; }
int stat(char *file, void* st) { return -1; }
//int times(struct tms *buf) { return -1; }
int times(void* buf) { return -1; }
int unlink(char *name) { return -1; }
int wait(int *status) { return -1; }
int write(int file, char *ptr, int len) { return -1; }
long sbrk(int incr) { return -1; }

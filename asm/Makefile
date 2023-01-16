objects = build/glad.o build/compile_shader.o build/computer_pad_controllers.o build/geim_init.o build/glfw_callbacks.o build/load_gl_objects.o build/main.o build/mouse_control_pad_fun.o build/gl_objects.o build/consts.o build/perspective_matrix.o build/transformation_matrix.o build/state_objects.o build/logic.o
GLFW_LIB_FLAGS = `pkg-config --libs glfw3`

all: run

run: geim
	./geim

dbg: geim
	gdb ./geim

geim: $(objects)
	$(CC) $(GLFW_LIB_FLAGS) -no-pie -o $@ $^

build:
	mkdir build

build/%.o: %.s | build
	$(CC) -no-pie -g3 -c -o $@ $<

build/glad.o: glad/src/glad.c | build
	$(CC) -c -o $@ $< -I glad/include

clean:
	rm -rf build geim geim.tar.xz

archive: clean geim
	tar -czf geim.tar.xz glad Makefile *.s geim "Asm game specification.pdf"

.PHONY: all run dbg archive clean

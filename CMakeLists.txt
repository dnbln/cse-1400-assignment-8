cmake_minimum_required(VERSION 3.24)
project(geim C)

set(CMAKE_C_STANDARD 99)

add_executable(geim main.c glad/src/glad.c geimImpl.c geimImpl.h)

target_include_directories(geim PRIVATE glad/include)
if(WIN32)
    target_include_directories(geim PRIVATE "C:/GLFW/include")

    target_link_libraries(geim PRIVATE "C:/GLFW/lib/libglfw3.a")
else()
    find_package(glfw3 3.3 REQUIRED)

    target_link_libraries(geim PRIVATE glfw m)
endif()


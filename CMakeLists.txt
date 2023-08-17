cmake_minimum_required(VERSION 3.16)

if(NOT QOMPASS_VERSION)
    message(WARNING "Notice: QOMPASS_VERSION variable was not set. Defaulting to 0.1")
    set(QOMPASS_VERSION "0.1")
endif()

project(qompass VERSION ${QOMPASS_VERSION} LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Quick Sensors Svg)

configure_file(main.cpp.in main.cpp @ONLY)

qt_add_executable(qompass
    ${CMAKE_BINARY_DIR}/main.cpp
)

qt_add_qml_module(qompass
    URI qompass
    VERSION 1.0
    QML_FILES Main.qml Theme.qml
)

set_property(TARGET qompass PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
    ${CMAKE_CURRENT_SOURCE_DIR}/android)

target_link_libraries(qompass
    PRIVATE Qt6::Quick
            Qt6::Sensors
            Qt6::Svg
)

qt_add_resources(qompass
        "main"
    PREFIX
        "/"
    FILES
        images/degrees_indicator.svg
        images/north_indicator.svg
        images/degrees_indicator_dark_theme.svg
)

install(TARGETS qompass
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)


/*
 * Copyright (C) 2023 Nicolas Morais
 * This program is free software; you can redistribute
 * it and/or modify it under the terms of the GNU
 * General Public License as published by the Free
 * Software Foundation; either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it
 * will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.

 * You should have received a copy of the GNU General
 * Public License along with this program; if not, see
 * <https://www.gnu.org/licenses>.
 */
pragma Singleton

import QtQuick
import QtCore

Item {
    id: root
    // app uses dark theme by default
    property bool isDark: settings.value("isDark", true)
    readonly property color background: isDark ? "black" : "white"
    readonly property color foreground: isDark ? "white" : "black"
    function toggleDarkTheme() {
        isDark = !isDark
    }

    Settings {
        id: settings
        property alias isDark: root.isDark
    }

    Component.onDestruction: settings.setValue("isDark", root.isDark)
}

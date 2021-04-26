workspace "Dark-Audio"
    architecture "x86_64"
    startproject "Dark-Audio"

    configurations
    {
        "Debug",
        "Release",
        "Dist"
    }

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder(solution directory)
IncludeDir = {}
IncludeDir["openal-soft"] = "Dark-Audio/vendor/openal-soft/include"

project "Dark-Audio"
    location "Dark-Audio"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++17"
    staticruntime "On"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp",
        "%{prj.name}/vendor/openal-soft/include/**.h"
    }

    defines
    {
        "_CRT_SECURE_NO_WARNINGS"
    }

    includedirs
    {
        "%{prj.name}/src",
        "%{prj.name}/vendor/openal-soft/include"
    }

    filter "system:windows"
        systemversion "latest"

        defines
        {

        }

filter "configurations:Debug"
    defines "DKAU_DEBUG"
    runtime "Debug"
    symbols "On"

filter "configurations:Release"
    defines "DKAU_RELEASE"
    runtime "Release"
    optimize "On"

filter "configurations:Dist"
    defines "DKAU_Dist"
    runtime "Release"
    optimize "On"
workspace "Dark-Audio"
    architecture "x86_64"
    startproject "Dark-Audio"

    configurations
    {
        "Debug",
        "Release",
        "Dist"
    }

    flags
    {
        "MultiProcessorCompile"
    }

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

group "Dependencies"
	include "Dark-Audio/vendor/OpenAL-Soft"
group ""

-- Include directories relative to root folder(solution directory)
IncludeDir = {}
IncludeDir["OpenAL-Soft"] = "Dark-Audio/vendor/OpenAL-Soft/include"

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
        "%{prj.name}/src/**.cpp"
    }

    defines
    {
        "_CRT_SECURE_NO_WARNINGS",
        "AL_LIBTYPE_STATIC"
    }

    includedirs
    {
        "%{prj.name}/src",
        "Dark-Audio/vendor/OpenAL-Soft/include",
		"Dark-Audio/vendor/OpenAL-Soft/src",
		"Dark-Audio/vendor/OpenAL-Soft/src/common"
    }

    links
    {
        "OpenAL-Soft"
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
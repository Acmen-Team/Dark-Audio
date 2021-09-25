#include <iostream>
#include <stdio.h>
#include <stdlib.h>

#include <AL/al.h>
#include <AL/alc.h>

#define MINIMP3_IMPLEMENTATION
#include "minimp3.h"
#include "minimp3_ex.h"

static mp3dec_t mp3d;

int main()
{
  std::cout << "Dark-Audio Engine" << std::endl;
  const ALchar* deviceName = nullptr;
  ALCdevice* device = nullptr;
  ALCcontext* context = nullptr;

  deviceName = alcGetString(nullptr, ALC_CAPTURE_DEFAULT_DEVICE_SPECIFIER);

  if (deviceName != nullptr)
  {

	device = alcOpenDevice(nullptr);

	if (device != nullptr)
	{
	  context = alcCreateContext(device, nullptr);
	  alcMakeContextCurrent(context);
	}

	alGetError();
	
	ALenum error = alGetError();
	if (error != AL_NO_ERROR)
	{
	  printf("alGenBuffers : %d", error);
	  return 0;
	}

	mp3dec_init(&mp3d);
	
	/*typedef struct
{
	int frame_bytes;
	int channels;
	int hz;
	int layer;
	int bitrate_kbps;
} mp3dec_frame_info_t;*/


	mp3dec_file_info_t info;
	int loadResult = mp3dec_load(&mp3d, "assets/Audio/test.mp3", &info, NULL, NULL);
	uint32_t size = info.samples * sizeof(mp3d_sample_t);

	auto sampleRate = info.hz;
	auto channels = info.channels;
	ALenum alFormat;
	switch (channels)
	{
	  case 1: alFormat = AL_FORMAT_MONO16;
	  case 2: alFormat = AL_FORMAT_STEREO16;
	}

	float lengthSeconds = size / (info.avg_bitrate_kbps * 1024.0f);

	ALuint buffer;
	alGenBuffers(1, &buffer);
	alBufferData(buffer, alFormat, info.buffer, size, sampleRate);

	ALuint source;
	alGenSources(1, &source);
	alSourcei(source, AL_BUFFER, buffer);

	if (alGetError() != AL_NO_ERROR)
	  std::cout << "Failed to setup sound source" << std::endl;

	alSourcePlay(source);
  }


  return std::cin.get();
}
import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { PodcastsService } from './podcasts.service';
import { CreatePodcastDto } from './dto/create-podcast.dto';
import { UpdatePodcastDto } from './dto/update-podcast.dto';

@Controller('podcasts')
export class PodcastsController {
  constructor(private readonly podcastsService: PodcastsService) {}

  @Post()
  create(@Body() createPodcastDto: CreatePodcastDto) {
    return this.podcastsService.create(createPodcastDto);
  }

  @Get()
  findAll() {
    return this.podcastsService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.podcastsService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updatePodcastDto: UpdatePodcastDto) {
    return this.podcastsService.update(+id, updatePodcastDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.podcastsService.remove(+id);
  }
}

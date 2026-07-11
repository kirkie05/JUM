import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { SermonsService } from './sermons.service';
import { CreateSermonDto } from './dto/create-sermon.dto';
import { UpdateSermonDto } from './dto/update-sermon.dto';

@Controller('sermons')
export class SermonsController {
  constructor(private readonly sermonsService: SermonsService) {}

  @Post()
  create(@Body() createSermonDto: any) {
    return this.sermonsService.create(createSermonDto);
  }

  @Get()
  findAll() {
    return this.sermonsService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.sermonsService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateSermonDto: any) {
    return this.sermonsService.update(id, updateSermonDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.sermonsService.remove(id);
  }
}

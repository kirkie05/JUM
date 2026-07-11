import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SermonsService {
  constructor(private prisma: PrismaService) {}

  create(createSermonDto: any) {
    return this.prisma.sermon.create({
      data: createSermonDto,
    });
  }

  findAll() {
    return this.prisma.sermon.findMany({
      orderBy: { publishedAt: 'desc' },
    });
  }

  findOne(id: string) {
    return this.prisma.sermon.findUnique({
      where: { id },
    });
  }

  update(id: string, updateSermonDto: any) {
    return this.prisma.sermon.update({
      where: { id },
      data: updateSermonDto,
    });
  }

  remove(id: string) {
    return this.prisma.sermon.delete({
      where: { id },
    });
  }
}

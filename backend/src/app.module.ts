import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { UsersModule } from './users/users.module';
import { SermonsModule } from './sermons/sermons.module';
import { AuthModule } from './auth/auth.module';
import { PodcastsModule } from './podcasts/podcasts.module';

@Module({
  imports: [PrismaModule, UsersModule, SermonsModule, AuthModule, PodcastsModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}

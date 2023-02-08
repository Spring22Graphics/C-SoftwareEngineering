// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;

// Load other project modules
import Rectangle : Rectangle;

void main()
{
    // Load the SDL libraries from bindbc-sdl
    const SDLSupport ret = loadSDL();
    if(ret != sdlSupport){
        writeln("error loading SDL dll");
    }

    // Initialize SDL
    if(SDL_Init(SDL_INIT_VIDEO) !=0){
        writeln("SDL_Init: ", fromStringz(SDL_GetError()));
    }

    // Create an SDL window
    SDL_Window* window= SDL_CreateWindow("D example window",
                                        SDL_WINDOWPOS_UNDEFINED,
                                        SDL_WINDOWPOS_UNDEFINED,
                                        640,
                                        480,
                                        SDL_WINDOW_SHOWN);
    // Load the bitmap surface
    SDL_Surface* imgSurface = SDL_LoadBMP("./test.bmp");
    // Blit the surace
    SDL_BlitSurface(imgSurface,null,SDL_GetWindowSurface(window),null);
    // Update the window
    SDL_UpdateWindowSurface(window);
    // Delay for 1000 milliseconds
    SDL_Delay(1000);
    // Free the image
    SDL_FreeSurface(imgSurface);


	// Create a hardware accelerated renderer
    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
	if(renderer==null){
		writeln("ERROR: ", SDL_GetError());
	}



	// Create a bunch of Rectangles
	Rectangle[50] rectangles;
	foreach(ref element; rectangles){
		element.Setup(640,480);
	}

	// Run the main application  loop
	bool runApplication = true;
	while(runApplication){
		SDL_Event e;
		// Handle events
		while(SDL_PollEvent(&e) !=0){
			if(e.type == SDL_QUIT){
				runApplication= false;
			}
		}
		// Clear the screen 
		SDL_SetRenderDrawColor(renderer, 0x22,0x22,0x55,0xFF);
		SDL_RenderClear(renderer);

		foreach(ref element ; rectangles){
			element.Update(640,480);
			element.Render(renderer);
		}

		SDL_RenderPresent(renderer);
		// Artificially slow things down
		SDL_Delay(16);
	}

	// Destroy our Renderer
	SDL_DestroyRenderer(renderer);
    // Destroy our window
    SDL_DestroyWindow(window);
    // Quit the SDL Application 
    SDL_Quit();

	writeln("Ending application--good bye!");

}
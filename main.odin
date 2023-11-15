package main

import rl "vendor:raylib"
import "core:fmt"
import "core:mem"


window_width :: 1600
window_height :: 1600
canvas_width :: 800
canvas_height :: 800
num_pixels :: canvas_width * canvas_height


render_target : rl.RenderTexture2D
pixels : []rl.Color

main :: proc() {  
  rl.InitWindow(canvas_width,canvas_width,"raylib core example")
  monitor := rl.GetCurrentMonitor();
  pos_x := rl.GetMonitorWidth(monitor) / 2 - canvas_width / 2
  pos_y := rl.GetMonitorHeight(monitor) / 2 - canvas_height / 2
  rl.SetWindowPosition(pos_x,pos_y)
  rl.SetTargetFPS(60)

  //load a canvas to draw and get some colors to draw on that canvas!
  init_game()
  
  fmt.println(render_target.texture.format)

  droplet_pos := 10
  for !rl.WindowShouldClose() {
  
    //update the pixels
    update_game(droplet_pos)

    //draw the pixels
    draw_game()
    droplet_pos += 1
  }

  //cleanup
  end_game()
}

init_game :: proc() {
  pixels = make([]rl.Color,num_pixels)
  render_target = rl.LoadRenderTexture(canvas_width,canvas_height)
}

update_game :: proc(droplet : int) {
  mem.zero_slice(pixels);
  
  if droplet < 700 {
    pos := canvas_height * droplet + canvas_width / 2;
    droplet_width :: 8
    droplet_height :: 8
    droplet_size :: droplet_width * droplet_height
    for w := -4; w < 4; w += 1 {
      for h := -4; h < 4; h +=1 {
        pixels[pos + w + (h * canvas_width)] = rl.GOLD
      }
    }
  
    rl.UpdateTexture(render_target.texture,&pixels[0]) 
  }


}

draw_game :: proc() {
  
  rl.BeginDrawing()
  rl.ClearBackground(rl.RAYWHITE)
  rl.DrawTexture(render_target.texture,0,0,rl.WHITE)
  rl.EndDrawing()
}

end_game :: proc() {
  fmt.println("close window and unload opengl")

  delete(pixels)
  rl.UnloadRenderTexture(render_target)
  rl.CloseWindow()
}

use actix_web::{get, App, HttpServer, Responder, HttpResponse};
use actix_web::middleware::Logger;

#[get("/")]
async fn hello() -> impl Responder {
  HttpResponse::Ok()
    .body("Hello world!")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
  std::env::set_var("RUST_LOG", "actix_web=info");
  env_logger::init();

  HttpServer::new(|| {
    App::new()
      .wrap(Logger::default())
      .service(hello)
  })
    .bind(("0.0.0.0", 3000))?
    .run()
    .await
}

# lambda_init/init.py
import pg8000
import os
import urllib.parse
import ssl

def handler(event, context):
    db_url = os.environ["DATABASE_URL"]
    parsed = urllib.parse.urlparse(db_url)

    # Configurar SSL sin verificación (obligatorio en RDS)
    ssl_context = ssl.create_default_context()
    ssl_context.check_hostname = False
    ssl_context.verify_mode = ssl.CERT_NONE

    conn = pg8000.connect(
        user=parsed.username,
        password=parsed.password,
        host=parsed.hostname,
        port=parsed.port or 5432,
        database=parsed.path.lstrip('/'),
        ssl_context=ssl_context,
        timeout=30
    )

    # IMPORTANTE: Usar autocommit o ejecutar uno por uno
    conn.autocommit = True  # ← Esto evita el problema del commit final

    cursor = conn.cursor()

    # Leer y ejecutar el SQL línea por línea (más seguro)
    sql_file = os.path.join(os.path.dirname(__file__), "init.sql")
    with open(sql_file, "r", encoding="utf-8") as f:
        sql_content = f.read()

    # Dividir por ; pero ignorar los que estén dentro de comentarios o strings
    statements = [s.strip() for s in sql_content.split(';') if s.strip() and not s.strip().startswith('--')]

    for stmt in statements:
        # Saltar líneas vacías y comentarios
        if stmt.startswith('--') or not stmt:
            continue
        try:
            cursor.execute(stmt)
        except Exception as e:
            print(f"Error ejecutando: {stmt[:100]}...")
            print(f"Error: {e}")
            raise

    cursor.close()
    conn.close()

    return {"statusCode": 200, "body": "Base de datos inicializada correctamente"}
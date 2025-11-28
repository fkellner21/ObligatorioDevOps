import pg8000
import os
import urllib.parse
import ssl

def handler(event, context):
    db_url = os.environ["DATABASE_URL"]
    parsed = urllib.parse.urlparse(db_url)

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

    conn.autocommit = True 

    cursor = conn.cursor()

    sql_file = os.path.join(os.path.dirname(__file__), "init.sql")
    with open(sql_file, "r", encoding="utf-8") as f:
        sql_content = f.read()

    try:
        cursor.execute(sql_content)
    except Exception as e:
        print("Error ejecutando SQL completo")
        print(e)
        raise

    cursor.close()
    conn.close()

    return {"statusCode": 200, "body": "Base de datos inicializada correctamente"}
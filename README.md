# gelarlapak

## Prequisities
- Ruby 2.3.1
- Rails 5.2.6

## Unit Test (Rspec)
There is 65 unit tests in this application. Run the test with `rspec ./spec`.

## Data Seeds
Run `rake db:seed` to populate some data. You can login with existing user, with email `user@example.com` or `user2@example.com`. Both user has same password, `password`. You can use this user to login and hit some endpoint.


## Endpoint
### Register
Endpoint: `{{host}}/api/v1/register`.

Params: 
| params  | type |required/optional|
|---------|------|-----------------|
|name     |string|required         |
|email    |string|required         |
|password |string|required         |


Example request:
```bash
curl --request POST \
  --url http://localhost:3000/api/v1/register \
  --header 'Content-Type: multipart/form-data' \
  --header 'content-type: multipart/form-data; boundary=---011000010111000001101001' \
  --form name=Veno \
  --form email=veno@example.com \
  --form password=password
```

Example response:
```json
{
  "user": {
    "id": 10,
    "name": "Veno",
    "email": "veno@example.com",
    "status": "active"
  }
}
```

### Login
Endpoint: `{{host}}/api/v1/login`.

Params:
|params   |type  |required/optional|
|---------|------|-----------------|
|email    |string|required         |
|password |string|required         |

Example request:
```bash
curl --request POST \
  --url http://localhost:3000/api/v1/login \
  --header 'Content-Type: multipart/form-data' \
  --header 'content-type: multipart/form-data; boundary=---011000010111000001101001' \
  --form email=veno@example.com \
  --form password=password
```

Example response:
```json
{
  "user": {
    "id": 10,
    "name": "Veno",
    "email": "veno@example.com",
    "status": "active"
  },
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMCwiZXhwIjoxNjI3MTA5NzIxfQ.msg23SZD4m2F3zehjcVuOJwJJb33eaeGUtm_ZZv-soo"
}
```

Some endpoint is restricted, you can access it if you login. You will need this `token` to access restricted endpoint. I use JWT authentication in this application. This token will expired after 24 hours.


### Get Product List
Endpoint: `{{host}}/api/v1/products`.

Available Params:
|params       |type  |required/optional|
|-------------|------|-----------------|
|shop_type    |string|optional         |
|product_name |string|optional         |

In this application, we have shops. And every shop has their classification. I call it `shop_type`. Available `shop_type` is bronze, silver, gold, and diamond. So you can filter product list based on shop's classification.

Example request:
```bash
curl --request GET \
  --url http://localhost:3000/api/v1/products \
  --header 'Content-Type: multipart/form-data' \
  --header 'content-type: multipart/form-data; boundary=---011000010111000001101001' \
  --form shop_type=silver \
  --form product_name=car
```
Example response:
```json
{
  "products": [
    {
      "id": 11,
      "name": "Awesome Marble Car",
      "description": "Vitae ex tempora. Quis qui id. Et recusandae ea.",
      "average_rating": 3.5,
      "status": "active",
      "formatted_price": "$97",
      "shop_information": {
        "id": 16,
        "address": "Martinefurt",
        "description": "Nostrum perferendis laudantium. Labore soluta consectetur. Distinctio alias repudiandae.",
        "shop_type": "silver"
      }
    },
    {
      "id": 36,
      "name": "Awesome Plastic Car",
      "description": "Amet vitae et. Cumque dicta illo. Dolorem voluptatibus ut.",
      "average_rating": 4.6,
      "status": "active",
      "formatted_price": "$26",
      "shop_information": {
        "id": 10,
        "address": "Jonesview",
        "description": "Consequatur maiores et. Quaerat tempora optio. Ex maiores doloribus.",
        "shop_type": "silver"
      }
    },
    {
      "id": 44,
      "name": "Small Linen Car",
      "description": "Aut voluptatum adipisci. Occaecati voluptate quasi. Aut laboriosam assumenda.",
      "average_rating": 4.2,
      "status": "active",
      "formatted_price": "$33",
      "shop_information": {
        "id": 14,
        "address": "Adamston",
        "description": "Qui totam aliquid. Animi ut distinctio. Ut molestiae nobis.",
        "shop_type": "silver"
      }
    }
  ]
}
```

### Get Product Detail
Endpoint: `{{host}}/api/v1/products/:id`. You need `product_id` to access this endpoint. You can easily get it from product list endpoint above.

Example request:
```bash
curl --request GET \
  --url http://localhost:3000/api/v1/products/11
```
Example response:
```json
{
  "products": {
    "id": 11,
    "name": "Awesome Marble Car",
    "description": "Vitae ex tempora. Quis qui id. Et recusandae ea.",
    "average_rating": 3.5,
    "status": "active",
    "formatted_price": "$97",
    "shop_information": {
      "id": 16,
      "address": "Martinefurt",
      "description": "Nostrum perferendis laudantium. Labore soluta consectetur. Distinctio alias repudiandae.",
      "shop_type": "silver"
    },
    "variants": [
      {
        "id": 23,
        "name": "magenta",
        "formatted_price": "$97.37",
        "stock": 0
      }
    ]
  }
}
```

### Get User Cart
Endpoint: `{{host}}/api/v1/carts`.

You need token to access this endpoint, so you must login.

Header:
|headers              |type    |
|---------------------|--------|
|Authorization: Bearer|required|

Example request:
```bash
curl --request GET \
  --url http://localhost:3000/api/v1/carts \
  --header 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2MjcwNzEzOTh9.N2bSgpciuqxa8oLlcBo1ikS9ftORxG91pkK30wRNuvY'
```

Example response:
```json
{
  "carts": [
    {
      "shop_info": {
        "id": 2,
        "name": "Beier, Schowalter and Hansen",
        "address": "Collinstown",
        "shop_type": "silver"
      },
      "products": [
        {
          "cart_id": 20,
          "product_id": 40,
          "variant_id": 95,
          "name": "Awesome Silk Chair",
          "variant": "pink",
          "price": 52.1,
          "formatted_price": "$52.10",
          "quantity": 1,
          "stock": 3,
          "note": "Rem nihil ullam fuga."
        },
        {
          "cart_id": 6,
          "product_id": 6,
          "variant_id": 13,
          "name": "Small Aluminum Plate",
          "variant": "pink",
          "price": 99.58,
          "formatted_price": "$99.58",
          "quantity": 1,
          "stock": 1,
          "note": "no"
        }
      ]
    },
    {
      "shop_info": {
        "id": 9,
        "name": "Dooley, Kohler and Lind",
        "address": "Louellaview",
        "shop_type": "silver"
      },
      "products": [
        {
          "cart_id": 10,
          "product_id": 16,
          "variant_id": 34,
          "name": "Aerodynamic Leather Hat",
          "variant": "gold",
          "price": 78.29,
          "formatted_price": "$78.29",
          "quantity": 4,
          "stock": 4,
          "note": "Ipsam minus mollitia molestias."
        }
      ]
    },
    {
      "shop_info": {
        "id": 16,
        "name": "Lind-Keeling",
        "address": "Martinefurt",
        "shop_type": "silver"
      },
      "products": [
        {
          "cart_id": 7,
          "product_id": 14,
          "variant_id": 31,
          "name": "Small Silk Pants",
          "variant": "purple",
          "price": 30.9,
          "formatted_price": "$30.90",
          "quantity": 1,
          "stock": 4,
          "note": "no"
        }
      ]
    },
    {
      "shop_info": {
        "id": 11,
        "name": "Miller-Zulauf",
        "address": "Zackmouth",
        "shop_type": "bronze"
      },
      "products": [
        {
          "cart_id": 15,
          "product_id": 8,
          "variant_id": 18,
          "name": "Aerodynamic Leather Car",
          "variant": "maroon",
          "price": 32.9,
          "formatted_price": "$32.90",
          "quantity": 4,
          "stock": 3,
          "note": "Et voluptatem nostrum perspiciatis."
        }
      ]
    },
    {
      "shop_info": {
        "id": 12,
        "name": "Skiles, Hessel and Brekke",
        "address": "Lake Thad",
        "shop_type": "diamond"
      },
      "products": [
        {
          "cart_id": 11,
          "product_id": 5,
          "variant_id": 10,
          "name": "Aerodynamic Marble Watch",
          "variant": "gold",
          "price": 84.57,
          "formatted_price": "$84.57",
          "quantity": 4,
          "stock": 2,
          "note": "Et et est quo."
        },
        {
          "cart_id": 12,
          "product_id": 5,
          "variant_id": 11,
          "name": "Aerodynamic Marble Watch",
          "variant": "green",
          "price": 60.09,
          "formatted_price": "$60.09",
          "quantity": 4,
          "stock": 1,
          "note": "Possimus maxime necessitatibus amet."
        }
      ]
    }
  ]
}
```

### Update Cart
Endpoint: `{{host}}/api/v1/carts/:id`.

You can increase or decrease product quantity in your cart. Or you can remove unwanted products on your cart. You can get cart_id (`:id`) from cart list above.

Header:
|headers              |type    |
|---------------------|--------|
|Authorization: Bearer|required|

Available params:
|params       |type    |required/optional|notes                                                                |
|-------------|--------|-----------------|---------------------------------------------------------------------|
|quantity     |integer |required         |product quantity                                                     |
|status       |string  |required         |if you want to delete product from cart, set this params to `deleted`|

Example request:
```bash
curl --request PATCH \
  --url http://localhost:3000/api/v1/cart/7 \
  --header 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2MjcwNzEzOTh9.N2bSgpciuqxa8oLlcBo1ikS9ftORxG91pkK30wRNuvY' \
  --header 'Content-Type: multipart/form-data' \
  --header 'content-type: multipart/form-data; boundary=---011000010111000001101001' \
  --form status=deleted
```

Example response:
```json
{
  "success": true
}
```


### Create Order
Endpoint: `{{host}}/api/v1/orders`.

You can make order based on products in your cart. Just pass cart_ids when you create order. If your cart has multiple product from multiple shop, you will have order based on how many unique shop in your cart.

Example:
Your cart has 3 items.
- Product A1 from Shop X
- Product B1 from Shop X
- Product C1 from Shop Y

If you make order based on data above,you will have 2 orders (2 order codes/ 2 invoices). First, you have order with code `ABCDEF` (example), contain 2 products Product A1 and Product B1. And you also have order with code `GHIJKL` (example) with only one product, Product C1.

Header:
|headers              |type    |
|---------------------|--------|
|Authorization: Bearer|required|

Params:
|params       |type    |required/optional|note            |
|-------------|--------|-----------------|----------------|
|cart_ids     |array   |required         |array of cart_id|

Example request:
```bash
curl --request POST \
  --url http://localhost:3000/api/v1/orders \
  --header 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2MjcwNzEzOTh9.N2bSgpciuqxa8oLlcBo1ikS9ftORxG91pkK30wRNuvY' \
  --header 'Content-Type: application/json' \
  --data '{
	"cart_ids": [6, 10, 20]
}'
```
Success response:
```json
{
  "success": true
}
```

If some products in your cart is unavailable. Let say out of stock, you will get `failed response` with 422 response status.

Failed response:
```json
{
  "success": false,
  "message: "Something wrong."
}
```

### Order List
Endpoint: `{{host}}/api/v1/orders`.

Get current user's order list. Ordered by newest purchase.

Header:
|headers              |type    |
|---------------------|--------|
|Authorization: Bearer|required|

Example request:
```bash
curl --request GET \
  --url http://localhost:3000/api/v1/orders \
  --header 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2MjcwNzEzOTh9.N2bSgpciuqxa8oLlcBo1ikS9ftORxG91pkK30wRNuvY'
```

Example response:
```json
{
  "orders": [
    {
      "id": 9,
      "code": "4EC6KU",
      "status": "pending",
      "purchase_date": "23 July 2021 14:34",
      "total_price": 313.16,
      "formatted_total_price": "$313.16",
      "shop_info": {
        "id": 9,
        "name": "Dooley, Kohler and Lind",
        "address": "Louellaview",
        "shop_type": "silver"
      },
      "products": [
        {
          "id": 16,
          "name": "Aerodynamic Leather Hat",
          "variant": "gold",
          "quantity": 4,
          "price": 78.29,
          "sub_total": 313.16,
          "formatted_sub_total": "$313.16"
        }
      ]
    },
    {
      "id": 8,
      "code": "PYA03B",
      "status": "pending",
      "purchase_date": "23 July 2021 14:34",
      "total_price": 151.68,
      "formatted_total_price": "$151.68",
      "shop_info": {
        "id": 2,
        "name": "Beier, Schowalter and Hansen",
        "address": "Collinstown",
        "shop_type": "silver"
      },
      "products": [
        {
          "id": 6,
          "name": "Small Aluminum Plate",
          "variant": "pink",
          "quantity": 1,
          "price": 99.58,
          "sub_total": 99.58,
          "formatted_sub_total": "$99.58"
        },
        {
          "id": 40,
          "name": "Awesome Silk Chair",
          "variant": "pink",
          "quantity": 1,
          "price": 52.1,
          "sub_total": 52.1,
          "formatted_sub_total": "$52.1"
        }
      ]
    }
  ]
}
```

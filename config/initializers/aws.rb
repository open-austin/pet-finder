AWS.config(
  access_key_id: Figaro.env.s3_key_id,
  secret_access_key: Figaro.env.s3_secret
  )
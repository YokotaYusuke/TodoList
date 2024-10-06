export default interface Http {
  get<T>(url: string): Promise<T>

  post<T>(url: string, data: string): Promise<T>
}

export class NetworkHttp implements Http {
  async get<T>(url: string): Promise<T> {
    const response = await fetch(url)
    if (!response.ok) {
      throw new Error(response.statusText)
    }
    return await response.json()
  }

  async post<T>(url: string, data: string): Promise<T> {
    const option = {
      headers: {
        'Content-Type': 'application/json',
      },
      method: 'POST',
      body: data
    }
    const response = await fetch(url, option)
    if (!response.ok) {
      throw new Error(response.statusText)
    }
    return await response.json()
  }
}

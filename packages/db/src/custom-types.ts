import { customType } from 'drizzle-orm/pg-core';

export const geometry = customType<{ data: string }>({
  dataType() {
    return 'geometry(Point, 4326)';
  },
});
